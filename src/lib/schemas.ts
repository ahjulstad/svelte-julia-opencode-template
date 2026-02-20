import { z } from 'zod';

export const EigvalsResponse = z.object({
	matrix_size: z.number().int().positive(),
	eigenvalues: z.array(z.number())
});

export type EigvalsResponse = z.infer<typeof EigvalsResponse>;
