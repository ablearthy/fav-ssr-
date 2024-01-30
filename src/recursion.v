From mathcomp Require Import all_ssreflect.
From Coq Require Import Logic.FunctionalExtensionality.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.
(* Set Printing Coercions. *)

Inductive my_acc {A : Type} (r : A -> A -> Prop) (x : A) : Prop
  := my_acc_c of (forall y, r y x -> my_acc r y).

Print my_acc.
    
Inductive my_tree' :=
  | leaf'
  | node' of my_tree' & my_tree'.

Inductive my_tree :=
  | leaf
  | node of (bool -> my_tree).

Fixpoint count_biased (t : my_tree) :=
  match t with
  | leaf => 0
  | node n => 1 + 2 * (count_biased (n true)) + (count_biased (n false))
  end.
    
Fixpoint my_tree'_my_tree (t : my_tree') : my_tree :=
  match t with
  | leaf' => leaf
  | node' l r => node (fun b => if b then (my_tree'_my_tree l) else (my_tree'_my_tree r))
  end.

Fixpoint my_tree_my_tree' (t : my_tree) : my_tree' :=
  match t with
  | leaf => leaf'
  | node n => node' (my_tree_my_tree' (n true)) (my_tree_my_tree' (n false))
  end.

Lemma my_tree'_iso (t : my_tree') : t = my_tree_my_tree' (my_tree'_my_tree t).
Proof.
  elim: t=>//=.
  by move=> l<- r<-.
Qed.

Lemma my_tree_iso (t : my_tree) : t = my_tree'_my_tree (my_tree_my_tree' t).
Proof.
  elim: t=>//=.
  move=> b pred.
  congr (node _).
  rewrite -(pred true) -(pred false).
  by apply: functional_extensionality ; case.
Qed.

Print lt.

Print eqfun.

Print eta_expansion.

Search (_ =1 _).

  
Lemma m_div_n_le_n (m n n': nat) : n = n'.+1 -> m %% n < n.
Proof.
  move=>->.
  by rewrite ltn_mod.
Qed.

Print modn.
Print modn_rec.
Print ltn_pmod.
Print ltn_mod.

Lemma n_eq_n (n : nat) : n = n.
Proof. by []. Qed.

Fixpoint my_gcd (m n : nat) (prf : my_acc (fun x y => is_true (x < y)) m) (prf2 : is_true (n < m)) : nat :=
  (match n as n0 return n = n0 -> nat with
  | 0 => fun _ => m
  | n'.+1 => fun prf3 => match prf with
    | my_acc_c rec => @my_gcd n (m %% n) (rec _ prf2) (m_div_n_le_n m prf3)
    end
  end) (n_eq_n n).