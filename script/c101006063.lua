--深淵の宣告者
--Abyssal Adjudicator
--Script by nekrozar
function c101006063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101006063.cost)
	e1:SetTarget(c101006063.target)
	e1:SetOperation(c101006063.activate)
	c:RegisterEffect(e1)
end
function c101006063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c101006063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(att)
	Duel.SetTargetParam(rc)
end
function c101006063.tgfilter(c,rc,att)
	return c:IsFaceup() and c:IsRace(rc) and c:IsAttribute(att) and c:IsAbleToGrave()
end
function c101006063.activate(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c101006063.tgfilter,1-tp,LOCATION_MZONE,0,nil,rc,att)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_RULE)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c101006063.aclimit)
			e1:SetLabelObject(sg:GetFirst())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101006063.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
