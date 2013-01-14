Maak nieuwe sessie aan:
  tmux new-session -s {session-name}

Verbind bestaande sessie met terminal
  tmux attach-session -t {session-name}

Sessie losmaken van huidige terminal (d = detach)
  C-b, d

Nieuw scherm in sessie aanmaken (c = create)
  C-b, c

Huidige scherm sluiten (& = and ~= end)
  C-b, &
  + y (bevestigen dat je scherm wil sluiten)

Slecteer scherm
  C-b, {nummer}

Spring naar laatsts geselecteerde scherm (in mijn config is dit C-b, C-b)
  C-b, l

Volgende/ vorige scherm (n = next, p = previous)
  C-b, n
  C-b, p

Lijst van alle schermen, waaruit je kan kiezen (w = window)
  C-b, w

Zoek tekst in openstaande schermen (f = find)
  C-b, f, {zoek string}

Windows staan in onderin de 'status'-balk.
Elk 'window' kan uit meerdere 'panes' bestaan.
De standaard is dat een window maar 1 pane heeft.
Het laatste pane van een window sluiten, sluit ook het window.

tmux dialogen kun je allemaal annuleren door 'q' te typen.

Kopieer modus
  C-b, [

