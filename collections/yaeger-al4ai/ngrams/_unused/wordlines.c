
#include <stdio.h>

/*
 *  Read from stdin, replacing space with newline
 *  previous char was also a space (i.e. \n\n = end of paragraph).
 */


int main(int argc, char **argv)
{
  char prev, current;

  prev = current = '\0';
  while ((current = getc(stdin)) != EOF)
  {
    if (current == ' ')
      fprintf(stdout, (prev == ' ' ? "" : "\n"));
    else if (!(current == ' '))
      putc(current,stdout);
    prev = current;
  }
}
