
/* kernel.cl
 * Matrix multiplication
 * Device code.
 * Check out vectorAdd.cl as an example...
 */

// OpenCL Kernel
__kernel void matrixMul(__global float* C, __global float* A, __global float* B, int wA, int wB)
{
	int tx = get_global_id(0);
	int ty = get_global_id(1);

	float value = 0;

	for(int k=0; k < wA; ++k) {
		float eleA = A[ty * wA + k];
		float eleB = B[k * wB + wA];
		value += eleA * eleB;
	}

	C[ty * wA + tx] = value;
}
