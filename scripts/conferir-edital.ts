/**
 * SPEC 1.6 — Conferência do edital: imprime a estrutura e falha (código 1) se houver inconsistência.
 * Uso: pnpm edital:conferir
 */
import { calcularNota, editais, questoesPorBloco, validarEdital } from '../packages/core/src/index';

let falhou = false;

for (const c of editais) {
  console.log(`\n${c.nome} — ${c.cargo} (${c.banca}) · prova em ${c.dataProva}`);
  const q = questoesPorBloco(c);
  console.log(`Disciplinas: ${c.disciplinas.length}`);
  for (const d of c.disciplinas) {
    const pendentes = d.topicos.filter((t) => t.aConferir).length;
    console.log(`  [${d.bloco}] ${d.nome}: ${d.questoes} questões, ${d.topicos.length} tópicos (${pendentes} a conferir)`);
  }
  console.log(`Gerais: ${q.gerais} (peso ${c.blocos.gerais.peso}) · Específicos: ${q.especificos} (peso ${c.blocos.especificos.peso}) · Total: ${q.gerais + q.especificos}`);
  console.log(`Fórmula: (Gerais × ${c.blocos.gerais.peso} + Específicos × ${c.blocos.especificos.peso}) ÷ ${c.blocos.gerais.peso + c.blocos.especificos.peso} · mínimo ${c.notaMinima.toFixed(2)}`);

  const borda = calcularNota(c, { gerais: 18, especificos: 24 });
  console.log(`Teste de borda (18/30 e 24/40): final ${borda.final.toFixed(2)}, habilitado = ${borda.habilitado}`);

  const erros = validarEdital(c);
  if (erros.length > 0) {
    falhou = true;
    console.error(`ERROS:\n- ${erros.join('\n- ')}`);
  } else {
    console.log('Estrutura consistente.');
  }
  const totalPendentes = c.disciplinas.reduce((s, d) => s + d.topicos.filter((t) => t.aConferir).length, 0);
  if (totalPendentes > 0) {
    console.warn(`AVISO: ${totalPendentes} tópicos ainda a conferir contra o Anexo IV oficial (docs/specs/CONFERENCIA-EDITAL.md).`);
  }
}

process.exit(falhou ? 1 : 0);
