/**
 * Copyright (c) 2019 
 * @license MIT
 */

pub mod content {

  pub const DEFAULT_COLOR : u32 = 256;
  pub const DEFAULT_ATTR : u32  = (0 << 18) | (DEFAULT_COLOR << 9) | (256 << 0);

  pub const CHAR_DATA_ATTR_INDEX : u32 = 0;
  pub const CHAR_DATA_CHAR_INDEX : u32 = 1;
  pub const CHAR_DATA_WIDTH_INDEX : u32 = 2;
  pub const CHAR_DATA_CODE_INDEX : u32 = 3;

/**
 * Null cell - a real empty cell (containing nothing).
 * Note that code should always be 0 for a null cell as
 * several test condition of the buffer line rely on this.
 */
  pub const NULL_CELL_CHAR : char = '\u{0000}';
  pub const NULL_CELL_WIDTH : u32 = 1;
  pub const NULL_CELL_CODE : u32 = 0;

/**
 * Whitespace cell.
 * This is meant as a replacement for empty cells when needed
 * during rendering lines to preserve correct aligment.
 */
  pub const WHITESPACE_CELL_CHAR : char = ' ';
  pub const WHITESPACE_CELL_WIDTH : u32 = 1;
  pub const WHITESPACE_CELL_CODE : u32 = 32;

}

pub mod attributes {
// RGB constants
/**
* bit 1..8     blue in RGB, color in P256 and P16
*/
  pub const BLUE_MASK : u32 = 0xFF;
  pub const BLUE_SHIFT : u32 = 0;
  pub const PCOLOR_MASK : u32 = 0xFF;
  pub const PCOLOR_SHIFT : u32 = 0;

/**
  * bit 9..16    green in RGB
  */
  pub const GREEN_MASK : u32 = 0xFF00;
  pub const GREEN_SHIFT : u32 = 8;

/**
* bit 17..24   red in RGB
*/
  pub const RED_MASK : u32 = 0xFF0000;
  pub const RED_SHIFT : u32 = 16;

/**
* bit 25..26   color mode: DEFAULT (0) | P16 (1) | P256 (2) | RGB (3)
*/
  pub const CM_MASK : u32 = 0x3000000;
  pub const CM_DEFAULT : u32 = 0;
  pub const CM_P16 : u32 = 0x1000000;
  pub const CM_P256 : u32 = 0x2000000;
  pub const CM_RGB : u32 = 0x3000000;

/**
* bit 1..24  RGB room
*/
  pub const RGB_MASK : u32 = 0xFFFFFF;
}

pub mod fg_flags {
  /**
   * bit 27..31 (32nd bit unused)
   */
  pub const INVERSE : u32 = 0x4000000;
  pub const BOLD : u32 = 0x8000000;
  pub const UNDERLINE : u32 = 0x10000000;
  pub const BLINK : u32 = 0x20000000;
  pub const INVISIBLE : u32 = 0x40000000;
}

pub mod bg_flags {
  /**
   * bit 27..28 (upper 4 unused)
   */
  pub const ITALIC : u32 = 0x4000000;
  pub const DIM : u32 = 0x8000000;
}
