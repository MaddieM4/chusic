// Copyright MaddieM4

Event e;
1.412::second => dur Bar;
0.25::Bar => dur Beat;

fun void pattern_player(Event event, string sample_path, int pattern) {
  // Load sample
  SndBuf buf => Gain g => dac;
  me.dir() + sample_path => buf.read;
  0 => g.gain;

  // Play patterns
  while (true) {
    // Wait for "play a pattern" signal
    event => now;

    // Loop through bits from highest to lowest
    // Each bit represents 1/8 of a beat
    // So each byte (two hex digits) == a beat
    // and 4 beats == a bar
    for (31 => int pos; pos > 0; pos--) {
      1 << pos => int mask;
      if ((pattern & mask) != 0) {
        1 => g.gain;
        0 => buf.pos;
      }
      0.125::Beat => now;
    }
  }
}

//    00       0A       A0       00
// 00000000 00001010 10100000 00000000
spork ~ pattern_player(e, "kick.wav",  0x88000800);
spork ~ pattern_player(e, "clap.wav",  0x00800080);
spork ~ pattern_player(e, "hihat.wav", 0x000AA000);

while (true) {
  e.broadcast();
  1::Bar => now;
}
