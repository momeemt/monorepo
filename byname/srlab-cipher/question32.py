a = int(input())
index = a
prime_factor = []
print_prime_factor = ""

while a >= 2:
    for i in range(2,index):
        if a % i == 0:
            prime_factor += [i]
            a /= i
            break

for i in range(2,index):
    c = prime_factor.count(i)
    if c >= 2:
        print_prime_factor += str(i) + "^" + str(c) + " * "
    elif c == 1:
        print_prime_factor += str(i) + " * "

print(print_prime_factor[:-2])
