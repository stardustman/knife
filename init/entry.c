
#include "types.h"

int kern_entry()
{
    //0xB8000～0xBFFFF这个地址段便是映射到文本模式的显存的
    uint8_t *input = (uint8_t *)0xB8000;
    //uint8_t color = (0 << 4) | (15 & 0x0F);
    //黑底绿字  0x2
    uint8_t color = (0 << 4) | (15 & 0x2);
    /**
    http://wiki.0xffffff.org/posts/hurlex-4.html
    从0xB8000这个地址开始，每2个字节表示屏幕上显示的一个字符。
    从屏幕的第一行开始对应，一行接着一行的对应下去。
    而这两个字节的前一个是显示字符的ASCII码，
    后一个是控制这个字符颜色和属性的控制信息，这个字节的8个bit位表示不同的含义。
    **/  
    *input++ = 'H'; *input++ = color;
    *input++ = 'e'; *input++ = color;
    *input++ = 'l'; *input++ = color;
    *input++ = 'l'; *input++ = color;
    *input++ = 'o'; *input++ = color;
    *input++ = ','; *input++ = color;
    *input++ = ' '; *input++ = color;
    *input++ = 'O'; *input++ = color;
    *input++ = 'S'; *input++ = color;
    *input++ = ' '; *input++ = color;
    *input++ = 'K'; *input++ = color;
    *input++ = 'e'; *input++ = color;
    *input++ = 'r'; *input++ = color;
    *input++ = 'n'; *input++ = color;
    *input++ = 'e'; *input++ = color;
    *input++ = 'l'; *input++ = color;
    *input++ = '!'; *input++ = color;
    // 输出 github username：stardustman
    *input++ = 's'; *input++ = color;
    *input++ = 't'; *input++ = color;
    *input++ = 'a'; *input++ = color;
    *input++ = 'r'; *input++ = color;
    *input++ = 'd'; *input++ = color;
    *input++ = 'u'; *input++ = color;
    *input++ = 's'; *input++ = color;
    *input++ = 't'; *input++ = color;
    *input++ = 'm'; *input++ = color;
    *input++ = 'a'; *input++ = color;
    *input++ = 'n'; *input++ = color;
    *input++ = '!'; *input++ = color;
    *input++ = '!'; *input++ = color;
    


    return 0;
}

