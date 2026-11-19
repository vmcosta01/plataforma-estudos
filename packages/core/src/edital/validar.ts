import type { Bloco, Concurso } from './tipos';

export function questoesPorBloco(c: Concurso): Record<Bloco, number> {
  const soma: Record<Bloco, number> = { gerais: 0, especificos: 0 };
  for (const d of c.disciplinas) soma[d.bloco] += d.questoes;
  return soma;
}

/** Retorna a lista de problemas encontrados; lista vazia = edital consistente. */
export function validarEdital(c: Concurso): string[] {
  const erros: string[] = [];
  const soma = questoesPorBloco(c);

  for (const bloco of Object.keys(c.blocos) as Bloco[]) {
    const esperado = c.blocos[bloco].questoes;
    if (soma[bloco] !== esperado) {
      erros.push(`Bloco "${bloco}": disciplinas somam ${soma[bloco]} questões, edital prevê ${esperado}.`);
    }
    if (!(c.blocos[bloco].peso > 0)) erros.push(`Bloco "${bloco}": peso deve ser positivo.`);
  }

  const vistos = new Set<string>();
  for (const d of c.disciplinas) {
    if (vistos.has(d.nome)) erros.push(`Disciplina repetida: "${d.nome}".`);
    vistos.add(d.nome);
    if (!Number.isInteger(d.questoes) || d.questoes <= 0) {
      erros.push(`Disciplina "${d.nome}": número de questões inválido (${d.questoes}).`);
    }
    if (d.topicos.length === 0) erros.push(`Disciplina "${d.nome}": nenhum tópico cadastrado.`);
  }

  if (!/^\d{4}-\d{2}-\d{2}$/.test(c.dataProva)) erros.push(`Data da prova inválida: "${c.dataProva}".`);
  if (!(c.notaMinima >= 0 && c.notaMinima <= 10)) erros.push(`Nota mínima fora de 0 a 10: ${c.notaMinima}.`);

  return erros;
}
