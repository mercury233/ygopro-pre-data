--サラマングレイト・ギフト
--Salamangreat Gift
--Script by dest
function c101006067.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw (to grave)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006067,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101006067)
	e2:SetCost(c101006067.cost)
	e2:SetTarget(c101006067.drtg1)
	e2:SetOperation(c101006067.drop1)
	c:RegisterEffect(e2)
	--draw (link)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101006067,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101006067)
	e3:SetCondition(c101006067.drcon)
	e3:SetCost(c101006067.cost)
	e3:SetTarget(c101006067.drtg2)
	e3:SetOperation(c101006067.drop2)
	c:RegisterEffect(e3)
end
function c101006067.cfilter(c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101006067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006067.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101006067.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101006067.filter(c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101006067.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c101006067.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101006067.drop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101006067.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101006067.lfilter(c)
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return false end
	local mat=c:GetMaterial()
	return c:IsFaceup() and c:IsSetCard(0x220) and mat:IsExists(Card.IsLinkCode,1,nil,c:GetCode())
end
function c101006067.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101006067.lfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101006067.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101006067.drop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
