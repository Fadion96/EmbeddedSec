import numpy as np
from math import sqrt, floor
from scipy import special
import itertools

class TestSuite(object):

	def __init__(self, filename):
		with open(filename, "r") as f:
			self.bit_string = f.read().rstrip('\n')
			self.bit_array = np.array([int(d) for d in self.bit_string])
			self.bit_length = len(self.bit_array)

	def get_string(self):
		return self.bit_string

	def get_array(self):
		return self.bit_array

	def frequency_test(self):
		temp_array = self.bit_array.copy()
		temp_array[temp_array == 0] = -1
		bit_sum = np.sum(temp_array)
		s_sum = abs(bit_sum)/sqrt(self.bit_length)
		p_value = special.erfc(s_sum/sqrt(2))
		print(p_value)
		return p_value >= 0.01

	def frequency_block_test(self, block_length):
		number_of_blocks = floor(self.bit_length / block_length)
		chunks = [self.bit_array[i * block_length : (i + 1) * block_length] for i in range(number_of_blocks)]
		ones = [ np.count_nonzero(chunk)/block_length for chunk in chunks]
		chi_square_statistic = 4 * block_length *np.sum([(proportion - 0.5) ** 2 for proportion in ones])
		p_value = special.gammaincc(number_of_blocks / 2, chi_square_statistic / 2)
		print(p_value)
		return p_value >= 0.01

	def longest_run_of_ones_test(self):
		v = [0, 0, 0, 0]
		n_value = 16
		prob_values = [.2148, .3672, .2305, .1875]
		number_of_blocks = floor(self.bit_length / 8)
		chunks = [self.bit_array[i * 8 : (i + 1) * 8] for i in range(number_of_blocks)]
		runs_of_ones = np.array([max([sum(group) for bit, group in itertools.groupby(chunk) if bit ]) for chunk in chunks])
		v[0] = len(runs_of_ones[runs_of_ones <= 1])
		v[1] = len(runs_of_ones[runs_of_ones == 2])
		v[2] = len(runs_of_ones[runs_of_ones == 3])
		v[3] = len(runs_of_ones[runs_of_ones >= 4])
		test = [((v[i] - n_value * prob_values[i]) ** 2) / (n_value * prob_values[i]) for i in range(4)]
		chi_square_statistic = np.sum(test)
		p_value = special.gammaincc(3 / 2, chi_square_statistic / 2)
		print(p_value)
		return p_value >= 0.01

def main():
	a = TestSuite("output_results.txt")
	print(a.frequency_test())
	print(a.frequency_block_test(16))
	print(a.longest_run_of_ones_test())


if __name__ == '__main__':
	main()
