"use client";

import { useRef, useState } from "react";
import { useLang } from "./prefs";

export function Gallery({ images, name }: { images: string[]; name: string }) {
  const en = useLang() === "en";
  const dialog = useRef<HTMLDialogElement>(null);
  const [index, setIndex] = useState(0);
  const move = (step: number) => setIndex((index + step + images.length) % images.length);

  return (
    <>
      <div className="thumbs">
        {images.map((u, i) => (
          <button
            key={u}
            type="button"
            aria-label={en ? `Enlarge image ${i + 1} of ${name}` : `Agrandir l'image ${i + 1} de ${name}`}
            onClick={() => {
              setIndex(i);
              dialog.current?.showModal();
            }}
          >
            <img src={u} alt="" loading="lazy" />
          </button>
        ))}
      </div>
      <dialog
        ref={dialog}
        className="lightbox"
        onClick={(e) => e.target === dialog.current && dialog.current?.close()}
        onKeyDown={(e) => {
          if (e.key === "ArrowRight") move(1);
          if (e.key === "ArrowLeft") move(-1);
        }}
      >
        <img src={images[index]} alt={`${name}, image ${index + 1}`} loading="lazy" />
        <div className="bar">
          <button type="button" onClick={() => move(-1)} aria-label={en ? "Previous image" : "Image précédente"}>‹</button>
          <span>{index + 1} / {images.length}</span>
          <button type="button" onClick={() => move(1)} aria-label={en ? "Next image" : "Image suivante"}>›</button>
          <button type="button" onClick={() => dialog.current?.close()}>{en ? "Close" : "Fermer"}</button>
        </div>
      </dialog>
    </>
  );
}
