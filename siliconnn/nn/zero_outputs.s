/**
 * Reference implementation: https://github.com/brandon-gong/siliconnn/blob/main/ref_impl/nn.c#L21
 *
 * Zeros out all of the post-activation outputs in a network. Outputs are
 * retained for use by backpropagation, but since the feedforward function
 * accumulates outputs for each neuron by iteratively summing, outputs should be
 * reset to zero before each forward pass.
 * 
 * @param X0 a pointer to the network to zero outputs for
 * Returns nothing.
 */

.global _zero_outputs
.align 2

// Two layers, so two sets of outputs to zero out. One set is just a
// single value (the output, o2, of the single neuron in the second layer), and
// the other set is the #hidden_size outputs from the neurons in the hidden
// layer (o1).
_zero_outputs:
	FMOV D0, #0.0            // Store zero in a register for future STRs.
	STR D0, [X0, #56]        // nn->o2 = 0.0. #56 is found with offsetof() macro

	// Finished zeroing out layer two neuron output, get ready to loop through
	// all hidden layer neurons.
	MOV X1, #0               // int i = 0;
	LDR W2, [X0, #4]         // W2 = net->hidden_size
	LDR X3, [X0, #32]        // X3 is the location of net->o1[0]
for:
	CMP X1, X2               // i < net->hidden_size?
	B.GE endfor              // if not, exit the for loop
	LSL X4, X1, #3           // X4 = i * sizeof(double)
	STR D0, [X3, X4]         // store 0.0 into net->o1[i]
	ADD X1, X1, #1           // i++;
	B for                    // loop back to the for condition
	
	// Done zeroing outputs, just return (no stack space to deallocate or return
	// address to reload)
endfor:
	RET                      // Return
