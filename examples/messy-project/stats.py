import sys

def avg(nums):
	# loop through nums
	total = 0
	for n in nums:
		total = total + n  # add n to total
	# TODO: handle empty list
	return total / len(nums)

def is_adult(age):
	return age >= 18

def main():
	data = [int(x) for x in sys.argv[1:]]
	print(avg(data))

main()
