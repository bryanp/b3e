/*
  This software is licensed under the MPL-2.0 License.

  Copyright Bryan Powell, 2021.
*/

#include <math.h>
#include <ruby/ruby.h>

static const char ALPHABET[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

static const int INDEX[] = {
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
  52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
  -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
  -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
};

int COMPACT_MASK = 0x1E;
int MASK_5BITS = 0x1F;

VALUE cInvalid;

static VALUE rb_b3e_encode(VALUE self, VALUE rString) {
  char* string = StringValuePtr(rString);
  char encoded[RSTRING_LEN(rString) * 8 / 5 + 1];

  int64_t cursor1 = RSTRING_LEN(rString) * 8;
  int64_t cursor2;
  int64_t i;

  char j;
  char blen1;
  char blen2;
  char shift;
  unsigned char byte;
  int written = 0;

  while (1) {
    j = 0;
    i = 0;

    cursor2 = cursor1 - 6;
    if (cursor2 <= 0) {
      cursor2 = 0;
      blen1 = cursor1;
    } else {
      i = cursor2 / 8;
      j = cursor2 % 8;
      blen1 = (i + 1) * 8 - cursor2;
      if (blen1 > 6) {
        blen1 = 6;
      }
    }

    shift = 8 - j - blen1;
    byte = (unsigned char)string[i] >> shift & ((1 << blen1) - 1);
    if (blen1 < 6 && cursor2 > 0) {
      blen2 = 6 - blen1;
      byte = (byte << blen2) | ((unsigned char)string[i + 1] >> (8 - blen2));
    }

    if ((byte & COMPACT_MASK) == COMPACT_MASK) {
      if (cursor2 > 0 || byte > MASK_5BITS) {
        cursor2++;
      }

      byte &= MASK_5BITS;
    }

    cursor1 = cursor2;
    encoded[written] = ALPHABET[byte];
    written++;

    if (cursor2 <= 0) {
      break;
    }
  }

  return rb_str_new(encoded, written);
}

static VALUE rb_b3e_decode(VALUE self, VALUE rString) {
  char* string = StringValuePtr(rString);

  u_int64_t length = RSTRING_LEN(rString);
  u_int64_t size = length * 6 / 8;
  u_int64_t index;

  char decoded[size];
  u_int64_t cursor = size;
  unsigned char character;
  int x;
  int byte = 0;
  int position = 0;
  int cb;

  for (index = 0; index < length; index++) {
    character = string[index];
    x = INDEX[character];

    if (x == -1) {
      rb_raise(cInvalid, "encountered a character that is not in the base62 alphabet");
    }

    if (index == length - 1) {
      byte |= x << position;
      cb = position % 8;
      position += (cb == 0 ? 0 : 8 - cb);
    } else if ((x & COMPACT_MASK) == COMPACT_MASK) {
      byte |= x << position;
      position += 5;
    } else {
      byte |= x << position;
      position += 6;
    }

    if (position >= 8) {
      cursor--;
      decoded[cursor] = byte;
      position %= 8;
      byte >>= 8;
    }
  }

  if (position > 0) {
    cursor--;
    decoded[cursor] = byte;
  }

  if (cursor > 0) {
    char resized[size];

    for (index = 0; index < size; index++) {
      resized[index] = decoded[cursor + index];
    }

    return rb_str_new(resized, size - cursor);
  } else {
    return rb_str_new(decoded, size);
  }
}

void Init_b3e_ext(void) {
  VALUE mB3e = rb_const_get(rb_cObject, rb_intern("B3e"));
  cInvalid = rb_const_get(mB3e, rb_intern("Invalid"));

  rb_define_singleton_method(mB3e, "c_encode", rb_b3e_encode, 1);
  rb_define_singleton_method(mB3e, "c_decode", rb_b3e_decode, 1);
}
