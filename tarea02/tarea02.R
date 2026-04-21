my_var <- 30 # my_var is type of numeric
my_var <- "Sally" # my_var is now of type character (aka string)
my_var # print my_var
# numeric
x <- 10.5
class(x)
# integer
x <- 1000L
class(x)
# complex
x <- 9i + 3
class(x)
# character/string
x <- "R is exciting"
class(x)
# logical/boolean
x <- TRUE
class(x)
x <- 10.5
y <- 55
# Print values of x and y
x
y
# Print the class name of x and y
class(x)
class(y)
x <- 1000L
y <- 55L
# Print values of x and y
x
y
# Print the class name of x and y
class(x)
class(y)
x <- 3+5i
y <- 5i
# Print values of x and y
x
y
# Print the class name of x and y
class(x)
class(y)
x <- 1L # integer
y <- 2 # numeric
# convert from integer to numeric:
a <- as.numeric(x)
# convert from numeric to integer:
b <- as.integer(y)
# print values of x and y
x
y
# print the class name of a and b
class(a)
class(b)
y
x
b <- as.integer(y)
y
"hello"
'hello'
str <- "Hello"
str # print the value of str
str <- "Hello"
str # print the value of str
str <- "Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua."
str # print the value of str
str
str <- "Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua."
cat(str)
str <- "Hello World!"
nchar(str)
str <- "Hello World!"
grepl("H", str)
grepl("Hello", str)
grepl("X", str)
str1 <- "Hello"
str2 <- "World"
paste(str1, str2)
10 > 9    # TRUE because 10 is greater than 9
10 == 9   # FALSE because 10 is not equal to 9
10 < 9    # FALSE because 10 is greater than 9
a <- 10
b <- 9
a > b
a <- 200
b <- 33
if (b > a) {
print ("b is greater than a")
} else {
print("b is not greater than a")
}
10+5
my_var <- 3
my_var <<- 3
3 -> my_var
3 ->> my_var
my_var # print my_var
my_var
5 == 5 # TRUE because 5 is equal to 5
5 == 3 # FALSE because 5 is not equal to 3
5 != 3 # returns TRUE because 5 is not equal to 3
5 > 3 # returns TRUE because 5 is greater than 3
5 < 3 # returns FALSE because 5 is not less than 3
4 < 2
5 >= 3 # returns TRUE because 5 is greater than, or equal, to 3
5 <= 3 # returns FALSE because 5 is neither less than or equal to 3
