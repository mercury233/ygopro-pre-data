--インヴィンシブル・ヘイロー
--Invincible Halo
--Script by dest
function c101006076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCost(c101006076.cost)
	e2:SetOperation(c101006076.operation)
	c:RegisterEffect(e2)
end
function c101006076.cfilter(c)
	return c:IsFaceup() and c:IsType(0x58020C0) and c:IsAbleToRemoveAsCost()
end
function c101006076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006076.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101006076.cfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	local flag=0
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
end
function c101006076.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c101006076.distg)
	e1:SetLabel(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c101006076.distg(e,c)
	return c:IsType(e:GetLabel())
end
