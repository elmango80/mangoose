#!/usr/bin/env zsh
# Instalador idempotente de las dependencias de testing (zunit + revolver).
#
# Ambas herramientas son scripts zsh autocontenidos que se descargan desde
# sus repos oficiales y se construyen en `/opt/homebrew/bin` (Apple Silicon)
# o `/usr/local/bin` (Intel / Linux), sin requerir `sudo` cuando el destino
# es propiedad del usuario.
#
# Uso:
#   ./tests/install-deps.zsh

set -e

SCRIPT_DIR="${0:A:h}"
ROOT_DIR="${SCRIPT_DIR:h}"

# Localizar el bindir adecuado para esta máquina.
if [[ -d /opt/homebrew/bin && -w /opt/homebrew/bin ]]
then
  BINDIR=/opt/homebrew/bin
elif [[ -d /usr/local/bin && -w /usr/local/bin ]]
then
  BINDIR=/usr/local/bin
else
  BINDIR="${HOME}/.local/bin"
  mkdir -p "$BINDIR"
  echo "ℹ Usando $BINDIR (asegúrate de que esté en tu PATH)."
fi

TMPDIR_DEPS="$(mktemp -d -t mangoose-deps)"
trap "rm -rf '$TMPDIR_DEPS'" EXIT

# ─── revolver (dependencia de zunit) ───────────────────────────────────────────
if ! command -v revolver >/dev/null 2>&1
then
  echo "→ Instalando revolver en $BINDIR/revolver"
  git clone --quiet --depth 1 https://github.com/molovo/revolver.git "$TMPDIR_DEPS/revolver"
  install -m 0755 "$TMPDIR_DEPS/revolver/revolver" "$BINDIR/revolver"
else
  echo "✓ revolver ya instalado en $(command -v revolver)"
fi

# ─── zunit ─────────────────────────────────────────────────────────────────────
if ! command -v zunit >/dev/null 2>&1
then
  echo "→ Construyendo e instalando zunit en $BINDIR/zunit"
  git clone --quiet --depth 1 https://github.com/zunit-zsh/zunit.git "$TMPDIR_DEPS/zunit"
  (cd "$TMPDIR_DEPS/zunit" && ./build.zsh >/dev/null)
  install -m 0755 "$TMPDIR_DEPS/zunit/zunit" "$BINDIR/zunit"
else
  echo "✓ zunit ya instalado en $(command -v zunit)"
fi

echo ""
echo "✔ Dependencias de testing listas. Lanza la suite con:"
echo "    cd $ROOT_DIR && zunit run"
