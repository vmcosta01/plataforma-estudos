/**
 * SPEC 1.6 — Gera supabase/seed.sql a partir dos editais em packages/core (fonte única).
 * Uso: pnpm seed:gerar   ·   Nunca editar supabase/seed.sql à mão.
 * IDs determinísticos (UUID v5) permitem rodar o seed de novo sem duplicar.
 */
import { createHash } from 'node:crypto';
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { editais, validarEdital } from '../packages/core/src/index';

// Namespace fixo do projeto para UUID v5.
const NAMESPACE = '6b1f4d2a-3c5e-4f70-9a8b-1c2d3e4f5a6b';

function uuidV5(nome: string): string {
  const ns = Buffer.from(NAMESPACE.replace(/-/g, ''), 'hex');
  const hash = createHash('sha1').update(Buffer.concat([ns, Buffer.from(nome, 'utf8')])).digest();
  const b = Buffer.from(hash.subarray(0, 16));
  b[6] = (b[6]! & 0x0f) | 0x50;
  b[8] = (b[8]! & 0x3f) | 0x80;
  const h = b.toString('hex');
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-${h.slice(12, 16)}-${h.slice(16, 20)}-${h.slice(20)}`;
}

const q = (s: string): string => `'${s.replace(/'/g, "''")}'`;

const linhas: string[] = [
  '-- GERADO por scripts/gerar-seed.ts a partir de packages/core/src/editais. NÃO EDITAR À MÃO.',
  '-- Tópicos com a_conferir = true ainda não foram comparados com o Anexo IV oficial (SPEC 1.6).',
  '',
];

for (const c of editais) {
  const erros = validarEdital(c);
  if (erros.length > 0) {
    console.error(`Edital ${c.id} inválido:\n- ${erros.join('\n- ')}`);
    process.exit(1);
  }
  const cid = uuidV5(`concurso:${c.id}`);
  linhas.push(
    `insert into public.concurso (id, slug, nome, cargo, banca, data_prova, alternativas_por_questao, duracao_minutos, questoes_gerais, peso_gerais, questoes_especificos, peso_especificos, nota_minima, fonte) values`,
    `  (${q(cid)}, ${q(c.id)}, ${q(c.nome)}, ${q(c.cargo)}, ${q(c.banca)}, ${q(c.dataProva)}, ${c.alternativasPorQuestao}, ${c.duracaoMinutos}, ${c.blocos.gerais.questoes}, ${c.blocos.gerais.peso}, ${c.blocos.especificos.questoes}, ${c.blocos.especificos.peso}, ${c.notaMinima}, ${q(c.fonte)})`,
    `  on conflict (id) do update set nome = excluded.nome, cargo = excluded.cargo, banca = excluded.banca, data_prova = excluded.data_prova, questoes_gerais = excluded.questoes_gerais, peso_gerais = excluded.peso_gerais, questoes_especificos = excluded.questoes_especificos, peso_especificos = excluded.peso_especificos, nota_minima = excluded.nota_minima, fonte = excluded.fonte;`,
    '',
  );
  c.disciplinas.forEach((d, i) => {
    const did = uuidV5(`disciplina:${c.id}:${d.nome}`);
    linhas.push(
      `insert into public.disciplina (id, concurso_id, nome, bloco, questoes, ordem) values (${q(did)}, ${q(cid)}, ${q(d.nome)}, ${q(d.bloco)}, ${d.questoes}, ${i + 1})`,
      `  on conflict (id) do update set nome = excluded.nome, bloco = excluded.bloco, questoes = excluded.questoes, ordem = excluded.ordem;`,
    );
    d.topicos.forEach((t, j) => {
      const tid = uuidV5(`topico:${c.id}:${d.nome}:${t.nome}`);
      linhas.push(
        `insert into public.topico (id, disciplina_id, nome, ordem, a_conferir) values (${q(tid)}, ${q(did)}, ${q(t.nome)}, ${j + 1}, ${t.aConferir}) on conflict (id) do update set nome = excluded.nome, ordem = excluded.ordem, a_conferir = excluded.a_conferir;`,
      );
    });
    linhas.push('');
  });
}

const raiz = join(dirname(fileURLToPath(import.meta.url)), '..');
writeFileSync(join(raiz, 'supabase', 'seed.sql'), linhas.join('\n'), 'utf8');
console.log(`supabase/seed.sql gerado (${editais.length} edital(is)).`);
