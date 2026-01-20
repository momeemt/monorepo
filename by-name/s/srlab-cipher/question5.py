import math

def lcm (x, y):
    return (x * y) // math.gcd(x , y);

a,b=(int(x) for x in input().split())

print("最大公約数は: " + str(math.gcd(a,b)))
print("最小公倍数は: " + str(lcm(a,b)))
