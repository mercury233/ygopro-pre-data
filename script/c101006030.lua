--ゴキポール
--Gokipole
--Script by dest
function c101006030.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006030,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101006030)
	e1:SetTarget(c101006030.thtg)
	e1:SetOperation(c101006030.tgop)
	c:RegisterEffect(e1)
end
function c101006030.thfilter(c)
	return c:IsLevel(4) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function c101006030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006030.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101006030.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c101006030.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c101006030.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_NORMAL) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(101006030,1)) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c101006030.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetAttack())
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0
				and Duel.SelectYesNo(tp,aux.Stringid(101006030,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local tc2=g:Select(tp,1,1,nil)
				Duel.Destroy(tc2,REASON_EFFECT)
			end
		end
	end
end
