#!/usr/bin/env bash
# ✿ sorteia um peixe diferente a cada vez que o fastfetch roda
# onde colocar: ~/.config/fastfetch/random.sh  (chmod +x random.sh)
# cores: ordem dos slots $1 a $9 de cada logo

dir="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
shopt -s nullglob
logos=("$dir"/logos/*.txt)

# sem logos na pasta: avisa e roda o fastfetch normal
if [ ${#logos[@]} -eq 0 ]; then
  echo "random.sh: nenhum logo encontrado em $dir/logos/ (rode o install.sh)" >&2
  exec fastfetch "$@"
fi

# sorteia, mas nunca repete o peixe da última vez
last_file="$dir/.last_logo"
last="$(cat "$last_file" 2>/dev/null)"
candidates=()
for f in "${logos[@]}"; do
  [ "$f" != "$last" ] && candidates+=("$f")
done
[ ${#candidates[@]} -eq 0 ] && candidates=("${logos[@]}")
pick="${candidates[RANDOM % ${#candidates[@]}]}"
echo "$pick" > "$last_file"

case "$(basename "$pick" .txt)" in
  clownfish)
    c=("255;125;35" "250;245;235" "120;50;35" "35;25;30" "255;178;80" "255;255;255" "255;150;165" "255;255;255" "255;255;255") ;;
  koi)
    c=("248;244;240" "255;150;50" "120;140;170" "35;25;30" "190;215;235" "255;255;255" "255;140;150" "40;40;55" "235;80;40") ;;
  goldfish)
    c=("255;140;25" "255;190;60" "175;75;25" "35;20;20" "255;185;120" "255;235;210" "255;120;110" "255;255;255" "235;70;25") ;;
  swordfish)
    c=("70;95;150" "232;238;246" "130;160;205" "20;20;30" "45;65;115" "255;255;255" "255;150;165" "110;120;140" "170;215;240") ;;
  tilapia)
    c=("125;150;130" "165;185;150" "80;105;90" "30;30;30" "150;170;160" "225;235;215" "225;140;150" "195;208;185" "95;115;105") ;;
  pufferfish)
    c=("222;185;140" "245;225;200" "140;95;65" "25;25;40" "245;205;110" "255;255;255" "235;125;50" "95;65;50" "190;125;80") ;;
  tuna)
    c=("40;60;100" "225;235;242" "125;155;200" "30;30;40" "210;160;70" "255;255;255" "255;150;160" "100;130;165" "85;80;50") ;;
  salmon)
    c=("185;198;205" "240;244;246" "110;125;135" "30;30;35" "125;120;75" "255;255;255" "240;150;150" "35;40;50" "95;115;120") ;;
  angelfish)
    c=("245;205;40" "235;240;255" "115;90;220" "25;20;50" "215;225;60" "255;255;200" "250;150;120" "50;40;150" "255;255;255") ;;
  catfish)
    c=("165;150;155" "205;220;215" "95;85;105" "30;25;30" "110;140;175" "255;255;255" "240;150;160" "205;195;200" "225;160;115") ;;
  *)
    c=() ;;
esac

# grava o logo e as cores sorteadas direto no config.jsonc (funciona em qualquer versão)
cfg="$dir/config.jsonc"
if [ -f "$cfg" ]; then
  sed -i -E "s#^([[:space:]]*\"source\":[[:space:]]*\").*(\",?)#\1${pick}\2#" "$cfg"
  for i in "${!c[@]}"; do
    n=$((i+1))
    sed -i -E "s#^([[:space:]]*\"${n}\":[[:space:]]*\")[^\"]*(\".*)#\138;2;${c[$i]}\2#" "$cfg"
  done
fi

command fastfetch "$@"
