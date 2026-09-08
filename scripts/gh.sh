#!/usr/bin/env bash
set -euo pipefail

# gh CLI 的安全封装:只放行指定的子命令和参数。
# 所有命令都通过 GH_REPO 或 GITHUB_REPOSITORY 限定在当前仓库内。
#
# 用法:
#   ./scripts/gh.sh issue view 123
#   ./scripts/gh.sh issue view 123 --comments
#   ./scripts/gh.sh issue list --state open --limit 20
#   ./scripts/gh.sh search issues "search query" --limit 10
#   ./scripts/gh.sh label list --limit 100

export GH_HOST=github.com

# 仓库名必须是 owner/repo 格式(不带更多斜杠),否则拒绝执行
REPO="${GH_REPO:-${GITHUB_REPOSITORY:-}}"
if [[ -z "$REPO" || "$REPO" == */*/* || "$REPO" != */* ]]; then
  echo "Error: GH_REPO or GITHUB_REPOSITORY must be set to owner/repo format (e.g., GITHUB_REPOSITORY=anthropics/claude-code)" >&2
  exit 1
fi
export GH_REPO="$REPO"

# 白名单:允许的旗标;其中这些旗标需要带值
ALLOWED_FLAGS=(--comments --state --limit --label)
FLAGS_WITH_VALUES=(--state --limit --label)

# 校验一级/二级子命令组合,只允许四种只读操作
SUB1="${1:-}"
SUB2="${2:-}"
CMD="$SUB1 $SUB2"
case "$CMD" in
  "issue view"|"issue list"|"search issues"|"label list")
    ;;
  *)
    echo "Error: only 'issue view', 'issue list', 'search issues', 'label list' are allowed (e.g., ./scripts/gh.sh issue view 123)" >&2
    exit 1
    ;;
esac

shift 2

# 把位置参数与旗标分开,并逐个校验旗标是否在白名单内
POSITIONAL=()
FLAGS=()
skip_next=false
for arg in "$@"; do
  if [[ "$skip_next" == true ]]; then
    # 上一个旗标需要值,本参数直接归入旗标值
    FLAGS+=("$arg")
    skip_next=false
  elif [[ "$arg" == -* ]]; then
    flag="${arg%%=*}"
    matched=false
    for allowed in "${ALLOWED_FLAGS[@]}"; do
      if [[ "$flag" == "$allowed" ]]; then
        matched=true
        break
      fi
    done
    if [[ "$matched" == false ]]; then
      echo "Error: only --comments, --state, --limit, --label flags are allowed (e.g., ./scripts/gh.sh issue list --state open --limit 20)" >&2
      exit 1
    fi
    FLAGS+=("$arg")
    # 旗标需要值且未使用 = 写法时,跳过下一个参数
    if [[ "$arg" != *=* ]]; then
      for vflag in "${FLAGS_WITH_VALUES[@]}"; do
        if [[ "$flag" == "$vflag" ]]; then
          skip_next=true
          break
        fi
      done
    fi
  else
    POSITIONAL+=("$arg")
  fi
done

# 搜索:禁止 repo:/org:/user: 限定符,防止越过当前仓库范围
if [[ "$CMD" == "search issues" ]]; then
  QUERY="${POSITIONAL[0]:-}"
  QUERY_LOWER=$(echo "$QUERY" | tr '[:upper:]' '[:lower:]')
  if [[ "$QUERY_LOWER" == *"repo:"* || "$QUERY_LOWER" == *"org:"* || "$QUERY_LOWER" == *"user:"* ]]; then
    echo "Error: search query must not contain repo:, org:, or user: qualifiers (e.g., ./scripts/gh.sh search issues \"bug report\" --limit 10)" >&2
    exit 1
  fi
  gh "$SUB1" "$SUB2" "$QUERY" --repo "$REPO" "${FLAGS[@]}"
elif [[ "$CMD" == "issue view" ]]; then
  # 查看 issue:必须且只能有一个纯数字编号
  if [[ ${#POSITIONAL[@]} -ne 1 ]] || ! [[ "${POSITIONAL[0]}" =~ ^[0-9]+$ ]]; then
    echo "Error: issue view requires exactly one numeric issue number (e.g., ./scripts/gh.sh issue view 123)" >&2
    exit 1
  fi
  gh "$SUB1" "$SUB2" "${POSITIONAL[0]}" "${FLAGS[@]}"
else
  # issue list / label list:不接受位置参数
  if [[ ${#POSITIONAL[@]} -ne 0 ]]; then
    echo "Error: issue list and label list do not accept positional arguments (e.g., ./scripts/gh.sh issue list --state open, ./scripts/gh.sh label list --limit 100)" >&2
    exit 1
  fi
  gh "$SUB1" "$SUB2" "${FLAGS[@]}"
fi
