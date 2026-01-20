# ユーグリッドの互除法を実装する
def gcd (a, b):

    if a % b == 0:
        return b
    elif b % (a % b) == 0:
        return a % b
    else:
        r1 = a % b
        r2 = b % (a % b)

        while r1 % r2 != 0:
            r3 = r1 % r2
            r1 = r2
            r2 = r3

        return r1

a,b=(int(x) for x in input().split())

print("最大公約数は: " + str(gcd(a,b)))
