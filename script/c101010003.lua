--海晶乙女クラウンテイル

--Scripted by nekrozar
function c101010003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010003)
	e1:SetCondition(c101010003.spcon)
	e1:SetCost(c101010003.spcost)
	e1:SetTarget(c101010003.sptg)
	e1:SetOperation(c101010003.spop)
	c:RegisterEffect(e1)
	--battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010003,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101010103)
	e2:SetCondition(c101010003.damcon1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101010003.damtg1)
	e2:SetOperation(c101010003.damop1)
	c:RegisterEffect(e2)
end
function c101010003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle()
end
function c101010003.costfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101010003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101010003.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c101010003.costfilter,1,1,REASON_COST,c)
end
function c101010003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010003.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetOperation(c101010003.damop2)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010003.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,math.ceil(ev/2))
end
function c101010003.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsControler(1-tp)
end
function c101010003.damfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK)
end
function c101010003.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010003.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c101010003.damop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c101010003.damcon3)
	e1:SetOperation(c101010003.damop3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010003.damcon3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010003.damfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetSum(Card.GetLink)*1000
	return Duel.GetBattleDamage(tp)<=ct
end
function c101010003.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
