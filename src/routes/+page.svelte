<script lang="ts">
	import { EigvalsResponse, type EigvalsResponse as EigvalsResponseType } from '$lib/schemas';
	import { ZodError } from 'zod';

	let n = $state(4);
	let result = $state<EigvalsResponseType | null>(null);
	let loading = $state(false);
	let error = $state<string | null>(null);

	async function compute() {
		loading = true;
		error = null;
		result = null;
		console.log(`[eigvals] requesting n=${n}`);
		try {
			const res = await fetch(`/api/eigvals/${n}`);
			if (!res.ok) throw new Error(`Server responded ${res.status}`);
			const data = await res.json();
			result = EigvalsResponse.parse(data);
			console.log(`[eigvals] result`, $state.snapshot(result));
		} catch (e) {
			if (e instanceof ZodError) {
				error = `Unexpected response shape: ${e.issues[0]?.message}`;
			} else {
				error = e instanceof Error ? e.message : 'Unknown error';
			}
			console.error(`[eigvals] error`, e);
		} finally {
			loading = false;
		}
	}
</script>

<div class="mx-auto max-w-2xl px-4 py-12">
	<header class="mb-10 text-center">
		<h1 class="mb-2 text-4xl font-bold tracking-tight text-gray-900">Eigenvalue Demo</h1>
		<p class="text-lg text-gray-500">
			Generates a random <em>n×n</em> symmetric matrix in Julia and computes its eigenvalues.
		</p>
	</header>

	<div class="rounded-lg border border-gray-200 bg-white p-8 shadow-sm">
		<div class="mb-6">
			<label for="matrix-size" class="mb-2 block text-sm font-medium text-gray-700">
				Matrix size <em>n</em> = {n}
			</label>
			<input
				id="matrix-size"
				type="range"
				min="2"
				max="6"
				bind:value={n}
				class="w-full accent-indigo-600"
			/>
			<div class="mt-1 flex justify-between text-xs text-gray-400">
				<span>2</span>
				<span>6</span>
			</div>
		</div>

		<button
			onclick={compute}
			disabled={loading}
			class="w-full rounded-md bg-indigo-600 px-4 py-2 text-sm font-semibold text-white hover:bg-indigo-700 disabled:opacity-50"
		>
			{loading ? 'Computing…' : 'Compute eigenvalues'}
		</button>

		{#if error}
			<div class="mt-6 rounded-md bg-red-50 p-4 text-sm text-red-700">
				{error}
			</div>
		{/if}

		{#if result}
			<div class="mt-6">
				<p class="mb-3 text-sm text-gray-500">
					Eigenvalues of a random {result.matrix_size}×{result.matrix_size} symmetric matrix:
				</p>
				<ol class="space-y-1">
					{#each result.eigenvalues as val, i}
						<li class="flex items-center gap-3 rounded px-3 py-1.5 text-sm odd:bg-gray-50">
							<span class="w-5 text-right text-gray-400">{i + 1}</span>
							<span class="font-mono text-gray-800">{val.toFixed(6)}</span>
						</li>
					{/each}
				</ol>
			</div>
		{/if}
	</div>

	<footer class="mt-8 text-center text-xs text-gray-400">
		Julia backend via <code>server/src/Server.jl</code> · types validated with Zod
	</footer>
</div>
