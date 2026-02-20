import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/svelte';
import Page from '../routes/+page.svelte';

describe('+page.svelte', () => {
	it('renders the welcome heading', () => {
		render(Page);
		expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent('Welcome to SvelteKit');
	});
});
