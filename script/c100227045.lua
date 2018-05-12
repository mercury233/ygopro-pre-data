--マズルフラッシュ・ドラゴン
--Flash Charge Dragon
--Script by mercury233
--not fully implemented
function c100227045.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2)
	--zone limit
	--destroy	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100227045,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c100227045.descon)
	e3:SetTarget(c100227045.destg)
	e3:SetOperation(c100227045.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100227045,1))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCondition(c100227045.negcon)
	e5:SetCost(c100227045.negcost)
	e5:SetTarget(c100227045.negtg)
	e5:SetOperation(c100227045.negop)
	c:RegisterEffect(e5)
end
function c100227045.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.band(ec:GetLinkedZone(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
	end
end
function c100227045.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100227045.cfilter,1,nil,e:GetHandler())
end
function c100227045.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100227045.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,1,nil)
	if tg:GetCount()>0 then
		Duel.HintSelection(tg)
		if Duel.Destroy(tg,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c100227045.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c100227045.costfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100227045.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100227045.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c100227045.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100227045.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100227045.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
