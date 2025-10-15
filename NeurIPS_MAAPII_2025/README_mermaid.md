# Artism Mermaid 图使用说明（Windows）

本目录包含 3 个 Mermaid 源文件（.mmd）：
- `fig_artism_theory.mmd`：理论结构（mindmap）
- `fig_artism_operation.mmd`：运作结构（生成—批评闭环）
- `fig_artism_sequence.mmd`：时序交互（参与者视角）

## 一键渲染为图片（推荐 PNG / PDF）
1) 安装 Node.js（如未安装）：https://nodejs.org/
2) 安装 Mermaid CLI：
```powershell
npm i -g @mermaid-js/mermaid-cli
```
3) 在 `NeurIPS_MAAPII_2025` 目录内执行（PowerShell）：
```powershell
mmdc -i fig_artism_theory.mmd -o artism_theory.png -b transparent
mmdc -i fig_artism_operation.mmd -o artism_operation.png -b transparent
mmdc -i fig_artism_sequence.mmd -o artism_sequence.png -b transparent
```
- 如需矢量：将输出改为 `.pdf`（或 `.svg`）：
```powershell
mmdc -i fig_artism_theory.mmd -o artism_theory.pdf
```

## 在 LaTeX 中插入
确保 `\usepackage{graphicx}`，然后：
```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=\linewidth]{artism_theory.png}
  \caption{Artism 理论结构}
  \label{fig:artism_theory}
\end{figure}

\begin{figure}[htbp]
  \centering
  \includegraphics[width=\linewidth]{artism_operation.png}
  \caption{Artism 运作结构（生成—批评闭环）}
  \label{fig:artism_operation}
\end{figure}
```
> 若用 PDF 输出，`xelatex`/`lualatex` 直接支持；若用 `pdflatex`，建议使用 PNG。

## 编辑提示
- 直接修改 `.mmd` 文件中的中文节点/层级即可。
- Mermaid 版本建议 ≥ 10.4（支持 mindmap）。
- 若节点文字过长，可用 `\n` 手动换行。 