import random

a,b=(int(x) for x in input().split())

r = a % b
other_number = b * random.randint(1,100) + r

print(str(a) + " ≡ " + str(other_number) + " (mod " + str(b) +")")
