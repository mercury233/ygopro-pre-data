--Revendread Evolution
--Script by dest
function c101004084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101004084+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101004084.target)
	e1:SetOperation(c101004084.activate)
	c:RegisterEffect(e1)
end
function c101004084.dfilter(c)
	return c:IsSetCard(0x106) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c101004084.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x106) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	local dg=Duel.GetMatchingGroup(c101004084.dfilter,tp,LOCATION_DECK,0,nil)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(c101004084.dlvfilter,1,nil,tp,mg,c,c:GetLevel())
	else
		return ft>-1 and mg:IsExists(c101004084.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function c101004084.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(c101004084.dlvfilter,1,nil,tp,mg,rc,rc:GetLevel()-c:GetRitualLevel())
	else return false end
end
function c101004084.dlvfilter(c,tp,mg,rc,lv)
	local lv=lv-c:GetRitualLevel()
	return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99)
end
function c101004084.selcheck(c,mg,dg,mat,rc)
	mat:AddCard(c)
	if c:IsLocation(LOCATION_DECK) then
		mg:Sub(dg)
	end
	local sum=mat:GetSum(Card.GetRitualLevel)
	local lv=rc:GetLevel()-sum
	return sum<=rc:GetLevel() and mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99)
end
function c101004084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c101004084.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101004084.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101004084.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		local dg=Duel.GetMatchingGroup(c101004084.dfilter,tp,LOCATION_DECK,0,nil)
		mg:Merge(dg)
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=Group.CreateGroup()
		local lv=tc:GetLevel()
		if ft<=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:FilterSelect(tp,c101004084.mfilterf,1,1,nil,tp,mg,dg,tc)
			lv=lv-mat2:GetFirst():GetRitualLevel()
			mat:Merge(mat2)
		end
		while lv~=0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local tg=mg:FilterSelect(tp,c101004084.selcheck,1,1,nil,mg,dg,mat,tc):GetFirst()
			mat:AddCard(tg)
			if tg:IsLocation(LOCATION_DECK) then
				mg:Sub(dg)
			else
				mg:RemoveCard(tg)
			end
			lv=lv-tg:GetRitualLevel()
		end
		tc:SetMaterial(mat)
		local mat3=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if mat3 then
			mat:Sub(mat3)
			Duel.SendtoGrave(mat3,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(101004084,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c101004084.descon)
		e1:SetOperation(c101004084.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101004084.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(101004084)~=0
end
function c101004084.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
