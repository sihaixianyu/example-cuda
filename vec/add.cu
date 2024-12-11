#include <cassert>
#include <iostream>

using std::cout;

__global__ void vec_add(int* a, int* b, int* c, int num_elems) {
    int thread_id = (blockIdx.x * blockDim.x) + threadIdx.x;

    if (thread_id < num_elems) {
        c[thread_id] = a[thread_id] + b[thread_id];
    }
}

void verify_result(int* a, int* b, int* c, int N) {
    for (int i = 0; i < N; i++) {
        assert(c[i] == a[i] + b[i]);
        if (i >= N - 3) {
            cout << "Compute from GPU: " << c[i] << '\n';
            cout << "Ground True is: " << a[i] + b[i] << '\n';
        }
    }
}

int main() {
    constexpr auto num_elems = 1 << 26;
    size_t bytes = sizeof(int) * num_elems;

    int* host_a;
    int* host_b;
    int* host_c;

    cudaMallocHost(&host_a, bytes);
    cudaMallocHost(&host_b, bytes);
    cudaMallocHost(&host_c, bytes);

    for (size_t i = 0; i < num_elems; i++) {
        host_a[i] = std::rand() % 100;
        host_b[i] = std::rand() % 100;
    }

    int* dev_a;
    int* dev_b;
    int* dev_c;
    cudaMalloc(&dev_a, bytes);
    cudaMalloc(&dev_b, bytes);
    cudaMalloc(&dev_c, bytes);

    cudaMemcpy(dev_a, host_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, host_b, bytes, cudaMemcpyHostToDevice);

    auto num_threads = 1 << 10;
    auto num_blocks = (num_elems + num_threads - 1) / num_threads;

    vec_add<<<num_blocks, num_threads>>>(dev_a, dev_b, dev_c, num_elems);

    cudaMemcpy(host_c, dev_c, bytes, cudaMemcpyDeviceToHost);

    verify_result(host_a, host_b, host_c, num_elems);

    cudaFreeHost(host_a);
    cudaFreeHost(host_b);
    cudaFreeHost(host_c);

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    cout << "COMPLETED SUCCESSFULLY" << '\n';

    return 0;
}
