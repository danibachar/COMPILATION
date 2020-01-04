
#include <stdio.h>

// class Student
struct Student
{
   int pin;
};
int d1 = 10 * 10;
int d2 = 71;
// char *s = "asdfafsdf";
struct Student s =  {.pin = 11};// = Student(11);
struct Student goo(int i1, int i2) {
  char * s1 = "asdfsa";
  return s;
}
// int d3 = d1 - d2;
int main() {
  struct Student v = goo(11, 12);
  printf("%d\n", s.pin);
}

// void foo(int x, int y) {
//   int v = x+y;
//   return;// y*x;
// }
//
// char* foo1(int x, int y) {
//   return "y*x";
// }
//
// int main()
// {
//   int i1 = 7;
//   int i2 = 10;
//   // Student *st = new Student();
//   // int *a = new int[100];
//   foo(i1, i2);
//   printf("%d\n", i1);
//   // printf("%d\n", foo(i1, i2));
// }
