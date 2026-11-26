/** Minuscules sans accents, pour que « seijuro » trouve « Seijūrō ». */
export const fold = (s: string) =>
  s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
