--リンク・パーティー
--Link Party
--Script by nekrozar
function c100231010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100231010+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100231010.target)
	e1:SetOperation(c100231010.activate)
	c:RegisterEffect(e1)
end
function c100231010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c100231010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(c100231010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetAttribute)
	if chk==0 then return (ct==1 and Duel.IsExistingMatchingCard(c100231010.filter,tp,LOCATION_MZONE,0,1,nil))
	 	or (ct==2 and Duel.IsExistingMatchingCard(c100231010.filter,tp,0,LOCATION_MZONE,1,nil))
		or ct==3 or ct==4
		or (ct==5 and Duel.IsExistingMatchingCard(c100231010.spfilter,tp,LOCATION_DECK,0,1,nil))
		or (ct==6 and Duel.IsExistingMatchingCard(c100231010.desfilter,tp,0,LOCATION_MZONE,1,nil)) end
end
function c100231010.spfilter(c,e,tp)
	return c:IsAttackAbove(2500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100231010.desfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000)
end
function c100231010.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c100231010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetAttribute)
	local g1=Duel.GetMatchingGroup(c100231010.filter,tp,LOCATION_MZONE,0,nil)
	if ct==1 and g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		while tc1 do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			tc1=g1:GetNext()
		end
	end
	local g2=Duel.GetMatchingGroup(c100231010.filter,tp,0,LOCATION_MZONE,nil)
	if ct==2 and g2:GetCount()>0 then
		Duel.BreakEffect()
		local tc2=g2:GetFirst()
		while tc2 do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
			tc2=g2:GetNext()
		end
	end
	if ct==3 then
		Duel.BreakEffect()
		Duel.Recover(tp,1500,REASON_EFFECT)
	end
	if ct==4 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
	local g3=Duel.GetMatchingGroup(c100231010.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ct==5 and g3:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local g4=Duel.GetMatchingGroup(c100231010.desfilter,tp,0,LOCATION_MZONE,nil)
	if ct==6 and g4:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(g4,REASON_EFFECT)
	end
end
