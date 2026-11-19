export type { Bloco, Concurso, Disciplina, RegraBloco, Topico } from './edital/tipos';
export { questoesPorBloco, validarEdital } from './edital/validar';
export { calcularNota } from './nota/calcular';
export { arredondarCentesimos } from './nota/arredondar';
export type { Fracao, ResultadoNota } from './nota/calcular';
export { banestes2026TecnicoBancario } from './editais/banestes-2026-tecnico-bancario';

/** Todos os editais carregados na plataforma (fonte única para o seed do banco). */
import { banestes2026TecnicoBancario } from './editais/banestes-2026-tecnico-bancario';
export const editais = [banestes2026TecnicoBancario] as const;
