
use super::constants::*;

pub struct AttributeData {
    pub fg : u32,
    pub bg : u32
}

impl Clone for AttributeData {
  fn clone(&self) -> Self {
    AttributeData { fg: self.fg, bg: self.bg }
  }
}

impl Default for AttributeData {
  fn default() -> Self {
    AttributeData { fg: content::DEFAULT_ATTR, bg: content::DEFAULT_ATTR }
  }

}

impl AttributeData {
  pub fn new() -> Self {
    AttributeData { ..AttributeData::default() }
  }

  pub fn is_inverse(&self) ->    u32 { return self.fg & fg_flags::INVERSE; }
  pub fn is_bold(&self) ->       u32 { return self.fg & fg_flags::BOLD; }
  pub fn is_underline(&self) ->  u32 { return self.fg & fg_flags::UNDERLINE; }
  pub fn is_blink(&self) ->      u32 { return self.fg & fg_flags::BLINK; }
  pub fn is_invisible(&self) ->  u32 { return self.fg & fg_flags::INVISIBLE; }
  pub fn is_italic(&self) ->     u32 { return self.bg & bg_flags::ITALIC; }
  pub fn is_dim(&self) ->        u32 { return self.bg & bg_flags::DIM; }

  // color modes
  pub fn get_fg_color_mode(&self) -> u32 { return self.fg & attributes::CM_MASK; }
  pub fn get_bg_color_mode(&self) -> u32 { return self.bg & attributes::CM_MASK; }
  pub fn is_fg_rgb(&self) ->        bool { return (self.fg & attributes::CM_MASK) == attributes::CM_RGB; }
  pub fn is_bg_rgb(&self) ->        bool { return (self.bg & attributes::CM_MASK) == attributes::CM_RGB; }
  pub fn is_fg_palette(&self) ->    bool { return (self.fg & attributes::CM_MASK) == attributes::CM_P16 || (self.fg & attributes::CM_MASK) == attributes::CM_P256; }
  pub fn is_bg_palette(&self) ->    bool { return (self.bg & attributes::CM_MASK) == attributes::CM_P16 || (self.bg & attributes::CM_MASK) == attributes::CM_P256; }
  pub fn is_fg_default(&self) ->    bool { return (self.fg & attributes::CM_MASK) == 0; }
  pub fn is_bg_default(&self) ->    bool { return (self.bg & attributes::CM_MASK) == 0; }

  // colors
  pub fn get_fg_color(&self) -> u32 {
    match self.fg & attributes::CM_MASK {
      attributes::CM_P16 | attributes::CM_P256 => self.fg & attributes::PCOLOR_MASK,
      attributes::CM_RGB => self.fg & attributes::RGB_MASK,
      _ => 0xffffffff // CM_DEFAULT defaults to -1
    }
  }

  pub fn get_bg_color(&self) -> u32 {
    match self.bg & attributes::CM_MASK {
      attributes::CM_P16 | attributes::CM_P256 => self.bg & attributes::PCOLOR_MASK,
      attributes::CM_RGB => self.bg & attributes::RGB_MASK,
      _ => 0xffffffff  // CM_DEFAULT defaults to -1
    }
  }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn test_attr() {

  }
}

