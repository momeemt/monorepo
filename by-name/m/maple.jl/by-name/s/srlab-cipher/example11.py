a = int(input("当てさせる1~100までの数を入力してください: "))

min_number = 1
max_number = 100
order_number = 50

for i in range(7):
    order_number = (min_number + max_number) // 2
    print("アリス: 入力した数は" + str(order_number) + "ですか？")

    if order_number == a:
        print("ボブ: 正解")
        break
    elif order_number > a:
        print("ボブ: 小さい")
        max_number = order_number
    else:
        print("ボブ: 大きい")
        min_number = order_number
