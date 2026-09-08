#!/usr/bin/env bash
#
# 编辑 GitHub issue 上的标签。
# 用法:./edit-issue-labels.sh --add-label bug --add-label needs-triage --remove-label untriaged
#
# issue 编号从工作流事件载荷中读取。
#

set -euo pipefail

# 从事件载荷读取,使 issue 编号与触发事件绑定;
# 手动运行时回退到 workflow_dispatch 输入。
ISSUE=$(jq -r '.issue.number // .inputs.issue_number // empty' "${GITHUB_EVENT_PATH:?GITHUB_EVENT_PATH not set}")
if ! [[ "$ISSUE" =~ ^[0-9]+$ ]]; then
  echo "Error: no issue number in event payload" >&2
  exit 1
fi

ADD_LABELS=()
REMOVE_LABELS=()

# 解析命令行参数
while [[ $# -gt 0 ]]; do
  case $1 in
    --add-label)
      ADD_LABELS+=("$2")
      shift 2
      ;;
    --remove-label)
      REMOVE_LABELS+=("$2")
      shift 2
      ;;
    *)
      echo "Error: unknown argument (only --add-label and --remove-label are accepted)" >&2
      exit 1
      ;;
  esac
done

# 没有指定任何要添加或移除的标签,直接退出(报错)
if [[ ${#ADD_LABELS[@]} -eq 0 && ${#REMOVE_LABELS[@]} -eq 0 ]]; then
  exit 1
fi

# 从仓库拉取合法标签列表
VALID_LABELS=$(gh label list --limit 500 --json name --jq '.[].name')

# 过滤:只保留仓库中实际存在的标签
FILTERED_ADD=()
for label in "${ADD_LABELS[@]}"; do
  if echo "$VALID_LABELS" | grep -qxF "$label"; then
    FILTERED_ADD+=("$label")
  fi
done

FILTERED_REMOVE=()
for label in "${REMOVE_LABELS[@]}"; do
  if echo "$VALID_LABELS" | grep -qxF "$label"; then
    FILTERED_REMOVE+=("$label")
  fi
done

# 过滤后一个标签都不剩,无事可做,正常退出
if [[ ${#FILTERED_ADD[@]} -eq 0 && ${#FILTERED_REMOVE[@]} -eq 0 ]]; then
  exit 0
fi

# 拼装 gh 命令参数
GH_ARGS=("issue" "edit" "$ISSUE")

for label in "${FILTERED_ADD[@]}"; do
  GH_ARGS+=("--add-label" "$label")
done

for label in "${FILTERED_REMOVE[@]}"; do
  GH_ARGS+=("--remove-label" "$label")
done

gh "${GH_ARGS[@]}"

# 输出实际生效的添加/移除结果
if [[ ${#FILTERED_ADD[@]} -gt 0 ]]; then
  echo "Added: ${FILTERED_ADD[*]}"
fi
if [[ ${#FILTERED_REMOVE[@]} -gt 0 ]]; then
  echo "Removed: ${FILTERED_REMOVE[*]}"
fi
