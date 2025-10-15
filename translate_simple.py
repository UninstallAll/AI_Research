#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import sys

try:
    # 读取Excel文件
    df = pd.read_excel('IJPP/深度访谈对象list.xlsx')
    
    print("原始中文内容:")
    print("=" * 50)
    for index, row in df.iterrows():
        print(f"行 {index + 1}:")
        for col in df.columns:
            print(f"  {col}: {row[col]}")
        print()
    
    print("\n英文翻译:")
    print("=" * 50)
    
    # 创建英文翻译的DataFrame
    df_english = df.copy()
    
    # 翻译列名
    column_translations = {
        '序号': 'No.',
        '姓名': 'Name',
        '职位': 'Position',
        '单位': 'Organization',
        '联系方式': 'Contact',
        '访谈日期': 'Interview Date',
        '访谈时长': 'Duration',
        '访谈地点': 'Location',
        '主要话题': 'Main Topics',
        '备注': 'Notes'
    }
    
    # 重命名列
    for chinese_col, english_col in column_translations.items():
        if chinese_col in df_english.columns:
            df_english.rename(columns={chinese_col: english_col}, inplace=True)
    
    print("English Content:")
    print(df_english.to_string(index=False))
    
    # 保存英文版本
    df_english.to_excel('IJPP/In-depth_Interview_Subject_List_English.xlsx', index=False)
    print(f"\n英文版Excel文件已保存: IJPP/In-depth_Interview_Subject_List_English.xlsx")
    
except Exception as e:
    print(f"处理文件时出错: {e}")
    import traceback
    traceback.print_exc()


