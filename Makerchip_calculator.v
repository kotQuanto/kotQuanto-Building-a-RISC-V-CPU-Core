\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/calc_viz.tlv']).
   /* verilator lint_on WIDTH */
\TLV
   $reset = *reset;
   /* pierwsza wersja kalkulatora
   //val1 i val2 maja na starszych bitach 0, a mlodsze bity
   //sa losowe, val2<val1. Zabezpieczenie przed przepelnieniem
   $val1[31:0] = {26'd0, $val1_rand[5:0]};
   $val2[31:0] = {28'd0, $val2_rand[3:0]};
   */
   
   //druga wersja kalkulatora - output jest wejsciem do nastepnego dzialania
   $val1[31:0] = >>1$out[31:0];
   $val2[31:0] = {28'd0, $val2_rand[3:0]};
   
   //definicja podstawowych dzialan
   $sum[31:0]  = $val1 + $val2; //zakres wystarczy podac tylko raz
   $diff[31:0] = $val1 - $val2; 
   $prod[31:0] = $val1 * $val2;
   $quot[31:0] = $val1 / $val2;
   
   //wybor dzialania z multipleksera (odpowiednik else if)
   $out[31:0] = $reset ? 0 : //jesli reset to out = 0
                $op[1:0] == 2'b00 ? $sum :
                $op == 2'b01 ? $diff :
                $op == 2'b10 ? $prod :
                               $quot ; //rownowazne co $op == 2'b11 ? $quot;
      
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
   m4+calc_viz()
\SV
   endmodule
