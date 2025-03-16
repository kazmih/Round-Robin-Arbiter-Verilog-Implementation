module test3(clk , rst , req , grant);
input clk , rst;  
input [3:0] req;
output reg [3:0] grant;
reg [2:0] present_state;
reg [2:0] next_state;
parameter [2:0] S_IDLE = 3'b000;
parameter [2:0] S_0 = 3'b001;
parameter [2:0] S_1 = 3'b010;
parameter [2:0] S_2 = 3'b011;
parameter [2:0] S_3 = 3'b100;

always @(posedge clk or posedge rst) begin
if(rst)
present_state <= S_IDLE;
else
present_state <= next_state;
end

// Next State Logic
always @(*) begin
case (present_state)

S_IDLE : begin
if(req[0])
next_state = S_0;
else if(req[1])
next_state = S_1;
else if(req[2])
next_state = S_2;
else if(req[3])
next_state = S_3;
else
next_state = S_IDLE;
end

S_0 : begin
if(req[1])
next_state = S_1;
else if(req[2])
next_state = S_2;
else if(req[3])
next_state = S_3;
else if(req[0])
next_state = S_0;
else
next_state = S_IDLE;
end

S_1 : begin
if(req[2])
next_state = S_2;
else if(req[3])
next_state = S_3;
else if(req[0])
next_state = S_0;
else if(req[1])
next_state = S_1;
else
next_state = S_IDLE;
end

S_2 : begin
if(req[3])
next_state = S_3;
else if(req[0])
next_state = S_0;
else if(req[1])
next_state = S_1;
else if(req[2])
next_state = S_2;
else
next_state = S_IDLE;
end

S_3 : begin
if(req[0])
next_state = S_0;
else if(req[1])
next_state = S_1;
else if(req[2])
next_state = S_2;
else if(req[3])
next_state = S_3;
else
next_state = S_IDLE;
end

default : begin
if(req[0])
next_state = S_0;
else if(req[1])
next_state = S_1;
else if(req[2])
next_state = S_2;
else if(req[3])
next_state = S_3;
else
next_state = S_IDLE;
end
endcase
end

// Output Logic
always @(*) begin
case(present_state)
S_0 : grant = 4'b0001;
S_1 : grant = 4'b0010;
S_2 : grant = 4'b0100;
S_3 : grant = 4'b1000;
default : grant = 4'b0000;
endcase
end
endmodule

module test3_tb;
reg clk;
reg rst;
reg [3:0] req;
wire [3:0] grant;

test3 DUT(clk , rst , req , grant);

always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1; 
req = 4'b0000;
#5 rst = 0; 
@(posedge clk) req = 4'b0000; // Case 0 - No requests
@(posedge clk) req = 4'b0001; // Case 1 - Only req[0]
@(posedge clk) req = 4'b0010; // Case 2 - Only req[1]
@(posedge clk) req = 4'b0011; // Case 3 - req[1:0]
#20;
@(posedge clk) req = 4'b0100; // Case 4 - Only req[2]
@(posedge clk) req = 4'b0101; // Case 5 - req[2,0]
#20;
@(posedge clk) req = 4'b0110; // Case 6 - req[2:1]
#20;
@(posedge clk) req = 4'b0111; // Case 7 - req[2:0]
#30;
@(posedge clk) req = 4'b1000; // Case 8 - Only req[3]
@(posedge clk) req = 4'b1001; // Case 9 - req[3,0]
#20;
@(posedge clk) req = 4'b1010; // Case 10 - req[3,1]
#20;
@(posedge clk) req = 4'b1011; // Case 11 - req[3:1]
#30;
@(posedge clk) req = 4'b1100; // Case 12 - req[3:2]
#20;
@(posedge clk) req = 4'b1101; // Case 13 - req[3:2,0]
#30;
@(posedge clk) req = 4'b1110; // Case 14 - req[3:1]
#30;
@(posedge clk) req = 4'b1111; // Case 15 - All requests
#40;
#5 rst = 1; 
#100 $finish;
end
endmodule