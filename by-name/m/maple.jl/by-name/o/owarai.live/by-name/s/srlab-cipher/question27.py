import math as m

def phi(n):
    count = 0
    for i in range(1, n):
        if m.gcd(n, i) == 1:
            count += 1
    return count

a = int(input())
print(phi(a))
