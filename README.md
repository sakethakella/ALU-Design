<h1>16-bit ALU Design in Verilog</h1>

<p>
This project implements a modular 16-bit Arithmetic Logic Unit (ALU) in Verilog, complete with support for <strong>arithmetic</strong>, <strong>bitwise</strong>, and <strong>shift</strong> operations. The ALU design is fully parameterized with a clean separation of datapath and control path, making it easy to understand, test, and extend.
</p>

<hr>

<h2>🚀 Features</h2>
<ul>
  <li>✅ 16-bit <strong>Addition</strong> and <strong>Subtraction</strong> with flag generation</li>
  <li>✅ <strong>Bitwise AND, OR, XOR</strong></li>
  <li>✅ <strong>Logical and Arithmetic Shifts</strong></li>
  <li>✅ Modular design using:
    <ul>
      <li>Adder/Subtractor</li>
      <li>Bitwise Unit</li>
      <li>Shifter</li>
      <li>Multiplexers/Demultiplexers</li>
    </ul>
  </li>
  <li>✅ Control Path that configures operations using a 3-bit opcode</li>
  <li>✅ Output flags: <code>Zero</code>, <code>Negative</code>, <code>Overflow</code>, <code>Carry Out</code></li>
</ul>

<hr>

<h2>🧠 Modules Overview</h2>
<table>
  <thead>
    <tr>
      <th>Module</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr><td><code>Adder_subractor</code></td><td>16-bit adder/subtractor with flags</td></tr>
    <tr><td><code>bitwiseunit</code></td><td>Performs AND, OR, XOR operations</td></tr>
    <tr><td><code>shifter</code></td><td>Performs left/right logical and arithmetic shifts</td></tr>
    <tr><td><code>demultiplexer</code></td><td>Routes inputs to appropriate ALU units</td></tr>
    <tr><td><code>multiplexer</code></td><td>Selects final output from ALU units</td></tr>
    <tr><td><code>datapath</code></td><td>Connects functional units based on control signals</td></tr>
    <tr><td><code>controlpath</code></td><td>Sets control signals based on opcode</td></tr>
  </tbody>
</table>

<hr>

<h2>🧪 Testbench</h2>
<p>A comprehensive testbench is provided to simulate and validate the ALU design. It covers:</p>
<ul>
  <li>Arithmetic overflow and negative results</li>
  <li>Zero result detection</li>
  <li>Bitwise correctness</li>
  <li>Shifting edge cases (e.g., MSB logic handling)</li>
</ul>

<h3>✅ Sample Output (Simulation)</h3>
<pre>
Time     | OP | A     | B     | C     | Zero | Neg | Oflow | Cout
-------- |----|-------|-------|-------|------|-----|--------|-----
11000    | 0  | 0019  | 000f  | 0028  |  0   |  0  |   0    |  0
22000    | 1  | 0019  | 000f  | 000a  |  0   |  0  |   0    |  0
33000    | 2  | ff00  | 0f0f  | 0f00  |  0   |  0  |   0    |  0
44000    | 3  | ff00  | 0f0f  | ff0f  |  0   |  1  |   0    |  0
55000    | 4  | aaaa  | 5555  | ffff  |  0   |  1  |   0    |  0
66000    | 5  | 0001  | 0000  | 0002  |  0   |  0  |   0    |  0
77000    | 6  | 8000  | 0000  | 4000  |  0   |  0  |   0    |  0
88000    | 7  | f000  | 0000  | e000  |  0   |  1  |   0    |  0
</pre>

<hr>

<h2>🛠️ Usage</h2>
<ol>
  <li>Clone this repository:
    <pre><code>git clone https://github.com/&lt;your-username&gt;/&lt;repo-name&gt;.git
cd &lt;repo-name&gt;</code></pre>
  </li>
  <li>Simulate with your preferred Verilog simulator:
    <ul>
      <li><strong>Icarus Verilog</strong>: <code>iverilog -o alu_tb alu.v alu_tb.v &amp;&amp; vvp alu_tb</code></li>
      <li><strong>ModelSim</strong>, <strong>Vivado</strong>, or <strong>GTKWave</strong> can also be used</li>
    </ul>
  </li>
  <li>View waveforms (<code>.vcd</code>) for debug using:
    <pre><code>gtkwave alu_tb.vcd</code></pre>
  </li>
</ol>

<hr>

<h2>📂 File Structure</h2>
<pre>
.
├── alu.v           # ALU modules (datapath, control path, submodules)
├── alu_tb.v        # Testbench for verification
├── README.md       # Project documentation
└── waveform.vcd    # Optional: Generated waveform (if using Icarus)
</pre>

<hr>

<h2>🧩 Opcodes Summary</h2>
<table>
  <thead>
    <tr><th>Opcode (<code>op</code>)</th><th>Operation</th></tr>
  </thead>
  <tbody>
    <tr><td><code>000</code></td><td>Addition</td></tr>
    <tr><td><code>001</code></td><td>Subtraction</td></tr>
    <tr><td><code>010</code></td><td>Bitwise AND</td></tr>
    <tr><td><code>011</code></td><td>Bitwise OR</td></tr>
    <tr><td><code>100</code></td><td>Bitwise XOR</td></tr>
    <tr><td><code>101</code></td><td>Left Logical Shift</td></tr>
    <tr><td><code>110</code></td><td>Right Logical Shift</td></tr>
    <tr><td><code>111</code></td><td>Arithmetic Right Shift</td></tr>
  </tbody>
</table>

<hr>

<h2>📝 License</h2>
<p>This project is open-source and free to use under the <strong>MIT License</strong>.</p>

<hr>

<h2>✍️ Author</h2>
<p>
Designed and maintained by <strong>&lt;Your Name / GitHub Handle&gt;</strong><br>
Feel free to reach out or contribute!
</p>

