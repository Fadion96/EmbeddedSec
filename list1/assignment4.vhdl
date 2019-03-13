entity assign4 is
  port (a, b, c : in bit; x, y : out bit);
  signal u1, u2, u3 : bit;
end assign4;

architecture behaviour of assign4 is
begin
  u1 <= a or b;
  u2 <= not (b or c);
  u3 <= a xor c;
  x <= not((not u1) or (not u2));
  y <= (not u2) and (not u3);

end behaviour;
