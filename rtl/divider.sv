module divider #(
    parameter   int     D_WIDTH     = 4
)(
    input   logic                   i_clk,
    input   logic                   i_rstn,
    input   logic   [D_WIDTH-1:0]   i_dividend,
    input   logic   [D_WIDTH-1:0]   i_divisor,
    input   logic                   i_start,
    output  logic                   o_done,
    output  logic   [D_WIDTH-1:0]   o_quotient,
    output  logic   [D_WIDTH-1:0]   o_remainder
);

    typedef enum logic [1:0] {
        IDLE,
        DIVIDING,
        DONE
    } state_t;

    state_t state_q, state_d;

    logic [D_WIDTH-1:0] dividend_q, dividend_d;
    logic [D_WIDTH-1:0] divisor_q, divisor_d;
    logic [D_WIDTH-1:0] accum_q, accum_d;
    logic [D_WIDTH-1:0] quotient_q, quotient_d;
    
    logic [$clog2(D_WIDTH+1)-1:0] count_q, count_d;

    logic [D_WIDTH:0] next_accum;

    assign next_accum = {accum_q, dividend_q[D_WIDTH-1]};

    always_comb begin
        state_d    = state_q;
        dividend_d = dividend_q;
        divisor_d  = divisor_q;
        accum_d    = accum_q;
        quotient_d = quotient_q;
        count_d    = count_q;

        o_done      = 1'b0;
        o_quotient  = quotient_q;
        o_remainder = accum_q;

        case (state_q)
            IDLE: begin
                if (i_start) begin
                    state_d    = DIVIDING;
                    dividend_d = i_dividend;
                    divisor_d  = i_divisor;
                    accum_d    = '0;
                    quotient_d = '0;
                    count_d    = D_WIDTH; 
                end
            end

            DIVIDING: begin
                if (next_accum >= {1'b0, divisor_q}) begin
                    accum_d    = next_accum - {1'b0, divisor_q};
                    quotient_d = {quotient_q[D_WIDTH-2:0], 1'b1};
                end else begin
                    accum_d    = next_accum[D_WIDTH-1:0];
                    quotient_d = {quotient_q[D_WIDTH-2:0], 1'b0};
                end
            
                dividend_d = {dividend_q[D_WIDTH-2:0], 1'b0};
                
                count_d    = count_q - 1;

                if (count_q == 1) begin
                    state_d = DONE;
                end
            end

            DONE: begin
                o_done  = 1'b1;
                state_d = IDLE; 
            end
            
            default: state_d = IDLE;
        endcase
    end

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            state_q    <= IDLE;
            dividend_q <= '0;
            divisor_q  <= '0;
            accum_q    <= '0;
            quotient_q <= '0;
            count_q    <= '0;
        end else begin
            state_q    <= state_d;
            dividend_q <= dividend_d;
            divisor_q  <= divisor_d;
            accum_q    <= accum_d;
            quotient_q <= quotient_d;
            count_q    <= count_d;
        end
    end

`ifndef DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/divider.vcd");
        $dumpvars(0, divider);
    end
`endif

endmodule
