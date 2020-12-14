#mirror.py

str1 = input()
str2 = ""

for i in range(len(str1)):
    str2 += str1[len(str1)-i-1]

print(str2)