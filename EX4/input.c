
#include <stdio.h>
#include <string.h>
// class Student
// struct Student
// {
//    int pin;
// };
// int d1 = 10 * 10;
// int d2 = 71;
// // char *s = "asdfafsdf";
// struct Student s =  {.pin = 11};// = Student(11);
// struct Student goo(int i1, int i2) {
//   char * s1 = "asdfsa";
//   return s;
// }
// // int d3 = d1 - d2;
// int main() {
//   struct Student v = goo(11, 12);
//   printf("%d\n", s.pin);
// }

// void foo(int x, int y) {
//   int v = x+y;
//   if (v > 10) {
//     printf("%d\n", 100);
//     return;
//   }
//   printf("%d\n", 10);
//   return;// y*x;
// }
//
// char * foo() {
//   char *grr = "dfgd";
//   return  grr;
// }
char* y = "123";
int main() {
  y = "12345";
  printf("%s\n", y);
  y = "123456";
  printf("%s\n", y);
  // printf("%s\n", x);
  // printf("%s\n", foo());
  //
  // char str[80];
  // strcpy_s(str, "these ");
  // strcat_s(str, "strings ");
  // strcat_s(str, "are ");
  // strcat_s(str, "concatenated.");
  // printf("%s\n", str);
}
// char* foo1(int x, int y) {
//   return "y*xdddddd";
// }
//
// int main()
// {
//   int i1 = 7;
//   int i2 = 10;
//   // Student *st = new Student();
//   if (i1 < 5) {
//       printf("%d\n", i1);
//       return 1;
//   }
//   // int *a = new int[100];
//   char* res = foo1(i1, i2);
//   printf("%s\n", res);
//   // printf("%d\n", foo(i1, i2));
// }

// int foo1(int i1, int i2) {
//   if (i1+i2 < 50) {
//     return i1-i2;
//   }
//   return i1+i2;
// }

// int main()
// {
//   int i = foo1(15,15);
//   printf("%d\n", i);
//   // PrintInt(i);
// }



// int IsPrime(int p)
// {
//     int i = 2;
//     int j = 2;
//     int k = 7;
//
//     while (i<p)
//     {
// 		    j = 2;
//         while (j<p)
//         {
//             if (i*j == p)
//             {
//                  return 0;
//             }
//             j = j+1;
//         }
//         i = i+1;
//     }
//     return 1;
// }
//
// void PrintPrimes(int start, int end)
// {
//     int p = start;
//
//     while (p < end+1)
//     {
//         if (IsPrime(p))
//         {
//             // PrintInt(p);
//             printf("%d\n", p);
//         }
//         p = p + 1;
//     }
// }
//
// int main()
// {
//     PrintPrimes(2, 100);
// }
