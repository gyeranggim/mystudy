#!/bin/bash
# .env의 GEMINI_API_KEY를 Supabase의 내 계정 데이터(mystudy 테이블)에 저장합니다.
cd "$(dirname "$0")"
KEY=$(grep -E '^GEMINI_API_KEY=' .env | head -1 | cut -d= -f2- | tr -d '\r"' | xargs)
[[ "$KEY" =~ ^[A-Za-z0-9_-]{20,}$ ]] || { echo ".env의 GEMINI_API_KEY가 비어 있거나 형식이 이상해요"; exit 1; }
npx --yes supabase db query --remote --yes "insert into public.mystudy(user_id,kind,id,data) select id,'state','hj_ai_v1',jsonb_build_object('v',jsonb_build_object('key','$KEY','model','gemini-2.5-flash')) from auth.users order by created_at limit 1 on conflict (user_id,kind,id) do update set data=excluded.data, updated_at=now()" -o table 2>&1 | tail -3
echo "완료: 앱에서 로그아웃 후 다시 로그인하거나 새로고침하세요"
