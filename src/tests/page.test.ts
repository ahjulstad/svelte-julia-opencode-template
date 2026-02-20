import { afterEach, describe, it, expect, vi, beforeEach } from 'vitest';
import { cleanup, render, screen, fireEvent } from '@testing-library/svelte';
import Page from '../routes/+page.svelte';

const mockEigvalsResponse = {
	matrix_size: 4,
	eigenvalues: [-2.123456, -0.456789, 1.234567, 3.456789]
};

describe('+page.svelte', () => {
	beforeEach(() => {
		vi.stubGlobal('fetch', vi.fn());
	});

	afterEach(() => {
		cleanup();
		vi.unstubAllGlobals();
	});

	it('renders the heading', () => {
		render(Page);
		expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent('Eigenvalue Demo');
	});

	it('renders the matrix size slider and compute button', () => {
		render(Page);
		expect(screen.getByRole('slider')).toBeInTheDocument();
		expect(screen.getByRole('button', { name: /compute eigenvalues/i })).toBeInTheDocument();
	});

	it('shows loading state while fetch is in flight', async () => {
		vi.mocked(fetch).mockReturnValue(new Promise(() => {}));
		render(Page);
		fireEvent.click(screen.getByRole('button', { name: /compute eigenvalues/i }));
		expect(await screen.findByRole('button', { name: /computing/i })).toBeInTheDocument();
	});

	it('displays eigenvalues on a successful response', async () => {
		vi.mocked(fetch).mockResolvedValue(
			new Response(JSON.stringify(mockEigvalsResponse), { status: 200 })
		);
		render(Page);
		fireEvent.click(screen.getByRole('button', { name: /compute eigenvalues/i }));
		expect(await screen.findByText('-2.123456')).toBeInTheDocument();
		expect(screen.getByText('3.456789')).toBeInTheDocument();
		expect(screen.getAllByRole('listitem')).toHaveLength(4);
	});

	it('shows an error when the response fails Zod validation', async () => {
		vi.mocked(fetch).mockResolvedValue(
			new Response(JSON.stringify({ wrong: 'shape' }), { status: 200 })
		);
		render(Page);
		fireEvent.click(screen.getByRole('button', { name: /compute eigenvalues/i }));
		expect(await screen.findByText(/unexpected response shape/i)).toBeInTheDocument();
	});

	it('shows an error when the server returns a non-ok status', async () => {
		vi.mocked(fetch).mockResolvedValue(new Response(null, { status: 500 }));
		render(Page);
		fireEvent.click(screen.getByRole('button', { name: /compute eigenvalues/i }));
		expect(await screen.findByText(/server responded 500/i)).toBeInTheDocument();
	});
});
