/** Bloco de conhecimentos da prova, cada um com seu peso na nota final. */
export type Bloco = 'gerais' | 'especificos';

export interface Topico {
  nome: string;
  /** true enquanto o texto não for comparado com o Anexo IV do edital oficial. */
  aConferir: boolean;
}

export interface Disciplina {
  nome: string;
  bloco: Bloco;
  /** Número de questões da disciplina na prova. */
  questoes: number;
  topicos: Topico[];
}

export interface RegraBloco {
  /** Total de questões do bloco segundo o quadro de provas do edital. */
  questoes: number;
  peso: number;
}

export interface Concurso {
  id: string;
  nome: string;
  cargo: string;
  banca: string;
  /** Data da prova objetiva, ISO (AAAA-MM-DD), fuso America/Sao_Paulo. */
  dataProva: string;
  alternativasPorQuestao: number;
  duracaoMinutos: number;
  blocos: Record<Bloco, RegraBloco>;
  /** Nota final mínima para habilitação (escala 0 a 10). */
  notaMinima: number;
  disciplinas: Disciplina[];
  fonte: string;
}
